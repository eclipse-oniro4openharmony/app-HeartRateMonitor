import { sensor } from '@kit.SensorServiceKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import Log from '../utils/Log';

interface HeartRateResponse {
  heartRate?: number;
  value?: number;
}

@Entry
@Component
struct Index {
  @State heartRate: number = 0;
  @State steps: number = 0;
  private context: common.UIAbilityContext | undefined = undefined;
  private atManager: abilityAccessCtrl.AtManager | null = null;
  @State heartRateButtonStatus: 'Start' | 'End' = 'Start';
  @State timer: number = 0;
  @State format: string = 'mm:ss'
  @State isTimerStart: boolean = false
  @State isMeasuring: boolean = false
  @State heartRateCounter: number = 0
  @State heartRateNum: number = 0
  @State heartRateResult: number = 0
  @State isTestFinish: boolean = false
  textTimerController: TextTimerController = new TextTimerController()

  aboutToAppear(): void {
    try {
      this.context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    } catch (e) {
      this.context = undefined;
    }

    this.atManager = abilityAccessCtrl.createAtManager();
    this.requestPermissionsAndStart();
  }

  async requestPermissionsAndStart(): Promise<void> {
    const perms: Permissions[] = ['ohos.permission.READ_HEALTH_DATA'];
    try {
      if (this.atManager && this.context) {
        const result = await this.atManager.requestPermissionsFromUser(this.context, perms);
        Log.info('permission request result: ' + JSON.stringify(result));
        // 简单检查授权状态（生产请详判每个权限）
      }
    } catch (err) {
      console.warn('permission request failed: ' + JSON.stringify(err));
    }
  }

  getAverageHeartRate(): number {
    return Math.round(this.heartRateCounter / this.heartRateNum);
  }

  startSensorListeners(): void {
    try {
      // Heart rate
      sensor.on(sensor.SensorId.HEART_RATE, (data: sensor.HeartRateResponse) => {
        const hr: number = (data as HeartRateResponse).heartRate ?? (data as HeartRateResponse).value ?? 0;
        if (typeof hr === 'number') {
          this.heartRate = hr;
          Log.info(`heart rate -> ${hr}`);
          this.heartRateCounter += hr
          this.heartRateNum++
          Log.info(`heart rate counter-> ${this.heartRateCounter}`);
          Log.info(`heart rate number-> ${this.heartRateNum}`);
          if (this.isTestFinish) {
            this.heartRateResult = this.getAverageHeartRate()
          }
        }
      });
    } catch (err) {
      console.error('startSensorListeners error: ' + JSON.stringify(err));
    }
  }

  onScreenOff(): void {
    try {
      sensor.off(sensor.SensorId.HEART_RATE);
      sensor.off(sensor.SensorId.PEDOMETER);
    } catch (e) {
      Log.error(`error: ${JSON.stringify(e)}`)
    }
  }

  startTimer(): void {
    this.textTimerController.start()
    this.isTimerStart = true
    this.isMeasuring = true
    this.isTestFinish = false
    this.startSensorListeners()
  }

  resetTimer(): void {
    this.textTimerController.reset()
    this.isTimerStart = false
    this.isMeasuring = false
    this.isTestFinish = false
  }

  finishTest(): void {
    this.isTestFinish = true
    this.isMeasuring = false
    this.isTimerStart = false
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        if (this.isMeasuring) {
          Row() {
            Text('Measuring...')
              .fontColor(Color.White)
          }
        }
        TextTimer({ isCountDown: true, count: 30000, controller: this.textTimerController })
          .format(this.format)
          .fontColor(Color.White)
          .fontSize(20)
          .visibility(this.isMeasuring ? Visibility.Visible : Visibility.None)
          .onTimer((utc: number, elapsedTime: number) => {
            console.info('textTimer notCountDown utc is：' + utc + ', elapsedTime: ' + elapsedTime)
            if (elapsedTime == 30) {
              this.finishTest()
            }
          })
      }
      .zIndex(1)
      .height('50%')
      .width('50%')
      .hitTestBehavior(this.isMeasuring ? HitTestMode.Transparent : HitTestMode.Default)

      Circle({ width: '100%', height: '100%' })
      Column() {
        if (!this.isMeasuring) {
          Stack() {
            Progress({ value: this.heartRate, total: 220, type: ProgressType.Ring })
            Image($r('app.media.heart'))
              .width(50)
          }

          if (this.isTestFinish) {
            Text(`Heart Rate: ${this.heartRateResult} bpm`)
              .margin({ top: 20 })
            if (this.heartRateResult < 60) {
              Text(`bradycardia`)
                .fontColor(Color.Orange)
                .margin({ top: 20 })
            } else if (this.heartRateResult >= 60 && this.heartRateResult < 100) {
              Text(`Normal`)
                .fontColor(Color.Green)
                .margin({ top: 20 })
            } else if (this.heartRateResult >= 100) {
              Text(`tachycardia`)
                .fontColor(Color.Red)
                .margin({ top: 20 })
            }
          }
        }
      }
      .width('100%')
      .height('100%')
      .padding(20)

      Column() {
        Button(this.isTimerStart ? 'End' : 'Start')
          .borderRadius(15)
          .fontColor(Color.Black)
          .backgroundColor(Color.White)
      }
      .onClick(() => {
        this.isTimerStart == true ? this.resetTimer() : this.startTimer()
      })
      .margin({ bottom: 30 })
      .zIndex(1)
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.End)
    }
  }
}