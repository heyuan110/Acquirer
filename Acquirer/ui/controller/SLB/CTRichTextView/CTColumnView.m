//inside CTColumnView.m
#import "CTColumnView.h"

@implementation CTColumnView

@synthesize images;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.images = [NSMutableArray array];
    }
    return self;
}

-(void)dealloc
{
    self.images= nil;
    [super dealloc];
}

-(void)setCTFrame:(id)frame
{
    ctFrame = frame;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((CTFrameRef)ctFrame, context);

//    // 不需要解析图片
//    for (NSArray* imageData in self.images) {
//        UIImage* img = [imageData objectAtIndex:0];
//        CGRect imgBounds = CGRectFromString([imageData objectAtIndex:1]);
//        CGContextDrawImage(context, imgBounds, img.CGImage);
//    }
}

@end