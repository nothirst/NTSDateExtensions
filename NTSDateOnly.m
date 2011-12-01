//
//  NTSDateOnly.m
//
//  Created by Kevin Hoctor on 11/25/09.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

#import "NTSDateOnly.h"

#import "NSDate_NTSExtensions.h"
#import "NTSYearMonth.h"

static NSTimeInterval dayTimeInterval = (60.0 * 60.0 * 24.0);

@implementation NTSDateOnly

@synthesize dateYMD;

+ (NSCalendar *)currentCalendar
{
	static NSCalendar *currentCalendar = nil;
	if (currentCalendar == nil) {
		currentCalendar = [[NSCalendar currentCalendar] retain];
	}
	return currentCalendar;
}

+ (NSCalendar *)standardizedCalendar
{
	static NSCalendar *standardizedCalendar = nil;
	if (standardizedCalendar == nil) {
		standardizedCalendar = [[NSCalendar currentCalendar] retain];
		[standardizedCalendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	}
	return standardizedCalendar;
}

+ (NTSDateOnly *)today
{
	return [[[NTSDateOnly alloc] init] autorelease];
}

+ (NTSDateOnly *)tomorrow
{
	NSDate *date = [[NSDate alloc] initWithTimeInterval:dayTimeInterval sinceDate:[NSDate date]];
	NTSDateOnly *dateOnly = [[[NTSDateOnly alloc] initWithDate:date] autorelease];
	[date release];
    
	return dateOnly;
}

+ (NTSDateOnly *)yesterday
{
	NSDate *date = [[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate date]];
	NTSDateOnly *ntsDateOnly = [[NTSDateOnly alloc] initWithDate:date];
	[date release], date = nil;
	return [ntsDateOnly autorelease];
}

+ (NTSDateOnly *)startOfMonthDate:(NTSDateOnly *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	return [[[NTSDateOnly alloc] initWithYear:[aDate year] month:[aDate month] day:1] autorelease];
}

+ (NTSDateOnly *)startOfYearDate:(NTSDateOnly *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	return [[[NTSDateOnly alloc] initWithYear:[aDate year] month:1 day:1] autorelease];
}

+ (NTSDateOnly *)startOfPreviousYearDate:(NTSDateOnly *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	return [[[NTSDateOnly alloc] initWithYear:[aDate year] - 1 month:1 day:1] autorelease];
}

+ (NTSDateOnly *)dateWithNumber:(NSNumber *)aNumber
{
	return [[[NTSDateOnly alloc] initWithNumber:aNumber] autorelease];
}

+ (NTSDateOnly *)dateOnlyWithDate:(NSDate *)aDate
{
	return [[[NTSDateOnly alloc] initWithDate:aDate] autorelease];
}

- (id)init
{
	return [self initWithDate:[NSDate date]];
}

- (id)initWithDate:(NSDate *)aDate
{
	NSUInteger aDateYMD = 0;
	if (aDate != nil) {
		NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:aDate];
		aDateYMD = ([comps year] * 10000) + ([comps month] * 100) + [comps day];
	}
	return [self initWithDateYMD:aDateYMD];
}

- (id)initWithYearMonth:(NTSYearMonth *)aYearMonth
{
	return [self initWithYear:[aYearMonth year] month:[aYearMonth month] day:[aYearMonth day]];
}

- (id)initWithDay:(NSInteger)aDay
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:[comps year] month:[comps month] day:aDay];
}

- (id)initWithMonth:(NSInteger)aMonth day:(NSInteger)aDay
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:[comps year] month:aMonth day:aDay];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:(NSDayCalendarUnit) fromDate:[NSDate date]];
	return [self initWithYear:aYear month:aMonth day:[comps day]];
}

- (id)initWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:aDay];
	[comps setMonth:aMonth];
	[comps setYear:aYear];
	NSDate *normalizedDate = [[NTSDateOnly currentCalendar] dateFromComponents:comps];
	[comps release], comps = nil;
	comps = [[NTSDateOnly currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:normalizedDate];
	NSUInteger aDateYMD = ([comps year] * 10000) + ([comps month] * 100) + [comps day];

	return [self initWithDateYMD:aDateYMD];
}

- (id)initWithNumber:(NSNumber *)aNumber
{
	return [self initWithDateYMD:[aNumber unsignedIntValue]];
}

- (id)initWithDateYMD:(NSUInteger)aDateYMD
{
	self = [super init];
	if (self != nil) {
		dateYMD = aDateYMD;
	}
	return self;
}

- (const char *)objCType
{
	return @encode(unsigned int);
}

- (unsigned int)unsignedIntValue
{
	return dateYMD;
}

- (unsigned int)intValue
{
	return dateYMD;
}

- (long long)longLongValue
{
	return dateYMD;
}

- (const char *)UTF8String
{
	return [[NSString stringWithFormat:@"%u", dateYMD] UTF8String];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%u", dateYMD];
}

- (NSString *)debugDescription
{
	return [NSString stringWithFormat:@"{\nyear: %d\nmonth: %d\nday: %d\n}", [self year], [self month], [self day]];
}

- (NSInteger)year
{
	return dateYMD / 10000;
}

- (NSInteger)month
{
	return (dateYMD / 100) % 100;
}

- (NSInteger)day
{
	return dateYMD % 100;
}

- (NSInteger)dayOfTheWeek
{
	NSDateComponents *comps = [[NTSDateOnly currentCalendar] components:NSWeekdayCalendarUnit fromDate:[self dateValue]];
	return [comps weekday]; 
}

- (NSDate *)dateValue
{
	if ([self intValue] == 0) {
		return nil;
	}

	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:[self day]];
	[comps setMonth:[self month]];
	[comps setYear:[self year]];
	NSDate *d = [[NTSDateOnly currentCalendar] dateFromComponents:comps];
	[comps release], comps = nil;
	return d;
}

- (NSNumber *)numberValue
{
	return [NSNumber numberWithUnsignedLong:dateYMD];
}

- (BOOL)isEqualTo:(NTSDateOnly *)aDate
{
	return (self.dateYMD == aDate.dateYMD) ? YES : NO;
}

- (BOOL)isLessThan:(NTSDateOnly *)aDate
{
	return (self.dateYMD < aDate.dateYMD) ? YES : NO;
}

- (BOOL)isLessThanOrEqualTo:(NTSDateOnly *)aDate
{
	return (self.dateYMD <= aDate.dateYMD) ? YES : NO;
}

- (BOOL)isGreaterThan:(NTSDateOnly *)aDate
{
	return (self.dateYMD > aDate.dateYMD) ? YES : NO;
}

- (BOOL)isGreaterThanOrEqualTo:(NTSDateOnly *)aDate
{
	return (self.dateYMD >= aDate.dateYMD) ? YES : NO;
}

- (NTSDateOnly *)dateByAddingDays:(NSInteger)days
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:days];
	NTSDateOnly *date = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
	[comps release], comps = nil;
	return [date autorelease];
}

- (NTSDateOnly *)dateByAddingWeeks:(NSInteger)weeks
{
	return [self dateByAddingDays:(weeks * 7)];
}

- (NTSDateOnly *)dateByAddingMonths:(NSInteger)months
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:months];
	NTSDateOnly *date = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
	[comps release], comps = nil;
	return [date autorelease];
}

- (NTSDateOnly *)dateByAddingYears:(NSInteger)years
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	NTSDateOnly *date = [[NTSDateOnly alloc] initWithDate:[[NSDate currentCalendar] dateByAddingComponents:comps toDate:[self dateValue] options:0]];
	[comps release], comps = nil;
	return [date autorelease];
}

- (NSInteger)timeIntervalInDaysSinceDate:(NTSDateOnly *)referenceDate
{
    return [[self dateValue] timeIntervalInDaysSinceDate:[referenceDate dateValue]];
}


@end
