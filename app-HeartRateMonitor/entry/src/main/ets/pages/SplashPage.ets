@Entry
@Component
struct SplashPage {
  @State flag: boolean = false;

  onPageShow(): void {
    this.getUIContext().animateTo({
      duration: 2000,
      onFinish: () => {
        //when the animation finish go the main page
        setTimeout(() => {
          this.getUIContext().getRouter().replaceUrl({ url: 'pages/Index' })
        }, 200)
      }
    }, () => {
      this.flag = true
    })
  }

  build() {
    Column() {
      if (this.flag) {
        Image($r('app.media.heart'))
          .width('50%')
          .logoStyle()
          .transition({
            type: TransitionType.Insert,
            opacity: 0,
            translate: { x: -150 },
            scale: {
              x: 2,
              y: 5
            }
          })
          .align(Alignment.Center)
        Text($r('app.string.heart_rate_monitor'))
          .titleStyle()
          .transition({
            type: TransitionType.Insert,
            opacity: 0,
            translate: { x: 150 }
          })
      }
      Blank()
    }
    .bgStyle()
  }
}

@Extend(Image)
function logoStyle() {
  .width(90)
  .height(90)
  .margin({ top: 25 })
}

@Extend(Text)
function titleStyle() {
  .fontSize(21)
  .fontColor(Color.Black)
  .fontWeight(FontWeight.Bold)
  .margin({ top: 15 })
}

@Styles
function bgStyle() {
  .width('100%')
  .height('100%')
  .backgroundColor(Color.White)
  .backgroundImageSize({ width: '100%', height: '100%' })
}
