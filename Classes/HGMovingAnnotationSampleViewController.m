//
//  HGMovingAnnotationSampleViewController.m
//  HGMovingAnnotationSample
//
//  Created by Rotem Rubnov on 14/3/2011.
//	Copyright (C) 2011 100 grams software
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//
//

#import "HGMovingAnnotationSampleViewController.h"
#import "HGMovingAnnotation.h"
#import "HGMovingAnnotationView.h"
@interface HGMovingAnnotationSampleViewController()
@property HGMovingAnnotationView *annotationView;
@property HGMovingAnnotation *movingObject;
@end
@implementation HGMovingAnnotationSampleViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	// create the path for the moving object
	NSString *nmeaLogPath = [[NSBundle mainBundle] pathForResource:@"path" ofType:@"nmea"];
	HGMapPath *path = [[HGMapPath alloc] initFromFile:nmeaLogPath];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadPath:) name:kPathLoadedNotification object:path];
    

    self.view.exclusiveTouch = true;
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void) didLoadPath : (NSNotification*) notification
{
	// initialize our moving object 
	HGMapPath *path = (HGMapPath*)[notification object];
	HGMovingAnnotation *movingObject = [[[HGMovingAnnotation alloc] initWithMapPath:path] autorelease]; //the annotation retains its path
	[path release];
	
	// add the annotation to the map
	[_mapView addAnnotation:movingObject];
	
	// zoom the map around the moving object
	MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
	MKCoordinateRegion region = MKCoordinateRegionMake(MKCoordinateForMapPoint(movingObject.currentLocation), span); 
	[_mapView setRegion:region animated:YES];
	
	// start moving the object 
	[movingObject start];
}

- (IBAction)btnClicked:(id)sender {
    NSString *nmeaLogPath = [[NSBundle mainBundle] pathForResource:@"path" ofType:@"nmea"];
	HGMapPath *path = [[HGMapPath alloc] initFromFile:nmeaLogPath];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCar:) name:kPathLoadedNotification object:path];
    
}

- (void) addCar : (NSNotification*) notification
{
	// initialize our moving object
	HGMapPath *path = (HGMapPath*)[notification object];
	self.movingObject = [[HGMovingAnnotation alloc] initWithMapPath:path] ; //the annotation retains its path
	[path release];
    
	// add the annotation to the map
	[_mapView addAnnotation:self.movingObject];
	
	// zoom the map around the moving object
	MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
	MKCoordinateRegion region = MKCoordinateRegionMake(MKCoordinateForMapPoint(self.movingObject.currentLocation), span);
	[_mapView setRegion:region animated:YES];
    [self.movingObject start];
    
	// start moving the object
}



#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(HGMovingAnnotation*)annotation;
{
      NSLog(@"view for annotation");
    NSString *kMovingAnnotationViewId = [NSString stringWithFormat:@"%@",annotation.title];
	
	self.annotationView = (HGMovingAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:kMovingAnnotationViewId];
	if (!self.annotationView) {
		self.annotationView = [[HGMovingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kMovingAnnotationViewId];
    }
	
	//configure the annotation view
	self.annotationView.image = [UIImage imageNamed:@"Painted_sportscar___top_view_by_balagehun1991.png"];
	self.annotationView.bounds = CGRectMake(0, 0, 10, 22.5); //initial bounds (default)
	self.annotationView.mapView = mapView;
	return self.annotationView;
	
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    // MKMapPoint temp  = self.movingObject.currentLocation;
    
    //[self.annotationView.layer removeAllAnimations];
    //dispatch_async(dispatch_get_main_queue(), ^{[self.annotationView setPosition:self.movingObject.currentLocation animated:true];});
    
    NSLog(@"Touches begun");
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

{
   // MKMapPoint temp  = self.movingObject.currentLocation;
      [super touchesMoved:touches withEvent:event];
//[self.annotationView.layer removeAllAnimations];
    //dispatch_async(dispatch_get_main_queue(), ^{[self.annotationView setPosition:self.movingObject.currentLocation animated:true];});
    NSLog(@"Touches moved");
    
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event

{
    // MKMapPoint temp  = self.movingObject.currentLocation;
    [self touchesBegan:touches withEvent:event];
    //[self.annotationView.layer removeAllAnimations];
    //dispatch_async(dispatch_get_main_queue(), ^{[self.annotationView setPosition:self.movingObject.currentLocation animated:true];});
    NSLog(@"Touches cancelled");
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{
    // MKMapPoint temp  = self.movingObject.currentLocation;
      [super touchesEnded:touches withEvent:event];
    //[self.annotationView.layer removeAllAnimations];
    //dispatch_async(dispatch_get_main_queue(), ^{[self.annotationView setPosition:self.movingObject.currentLocation animated:true];});
    NSLog(@"Touches ended");
    
}

-(void)move:(id *)sender {
     NSLog(@"moved");
 
    
}
@end
