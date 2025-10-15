import HeartRateSensor from '../sensors/hrSensor'
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'

@Entry
@Component
struct Index {
  @State heartRate: number = 0
  private atManager: abilityAccessCtrl.AtManager | null = null
  private context: common.UIAbilityContext | undefined = undefined

  private hrListener = (hr: number)=>{
    this.heartRate = hr
  }

  async requestPermissionsAndStart(): Promise<void> {
    const perms: Permissions[] = ['ohos.permission.READ_HEALTH_DATA']
    try {
      if (this.atManager && this.context) {
        const result = await this.atManager.requestPermissionsFromUser(this.context, perms)
        console.log('Permission request result: ' + JSON.stringify(result))
      }
    } catch (err) {
      console.error('Request permission failed: ' + JSON.stringify(err))
    }
  }

  aboutToAppear(): void {
    try{
      this.context = this.getUIContext().getHostContext() as common.UIAbilityContext
    }catch{
      this.context = undefined
    }
    this.atManager = abilityAccessCtrl.createAtManager()
    this.requestPermissionsAndStart()

    HeartRateSensor.subscribe(this.hrListener)
  }

  aboutToDisappear(): void {
    HeartRateSensor.unsubscribe(this.hrListener)
  }
  build() {
    Column() {
        Text(`Current heart rate: ${this.heartRate} bpm`)

      Button('Start')
        .onClick(()=>{
          console.log('Heart rate: ', this.heartRate)
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}