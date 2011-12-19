//
//  NSDate_NTSExtensions.m
//
//  Created by Kevin Hoctor on 3/16/08.
//  Copyright 2010 No Thirst Software LLC
//
//  Use of this code is freely permitted with no guarantees of it being bug free.
//  Simply include Kevin Hoctor in your credits if you utilize it.
//

#import "NSDate_NTSExtensions.h"

#import "NTSDateOnly.h"

static NSTimeInterval dayTimeInterval = (60.0 * 60.0 * 24.0);
static NSInteger standardizedHour = 12;

@implementation NSDate (NTSExtensions)

+ (NSCalendar *)currentCalendar
{
	return [NTSDateOnly currentCalendar];
}

+ (NSDate *)zeroHourDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)zeroHourToday
{
	return [NSDate zeroHourDate:[NSDate date]];
}

+ (NSDate *)zeroHourYesterday
{
	return [[[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate zeroHourToday]] autorelease];
}

+ (NSDate *)midnightDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)midnightToday
{
	return [NSDate midnightDate:[NSDate date]];
}

+ (NSDate *)midnightYesterday
{
	return [[[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate midnightToday]] autorelease];
}

+ (NSDate *)standardizedDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)standardizedDateWithYear:(NSInteger)aYear month:(NSInteger)aMonth day:(NSInteger)aDay
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:aYear];
	[comps setMonth:aMonth];
	[comps setDay:aDay];
	[comps setHour:standardizedHour];
	NSDate *date = [[NSDate currentCalendar] dateFromComponents:comps];
	[comps release], comps = nil;
	return date;
}

+ (NSDate *)standardizedToday
{
	return [NSDate standardizedDate:[NSDate date]];
}

+ (NSDate *)standardizedYesterday
{
	return [[[NSDate alloc] initWithTimeInterval:-dayTimeInterval sinceDate:[NSDate standardizedToday]] autorelease];
}

+ (NSDate *)standardizedTomorrow
{
	return [[[NSDate alloc] initWithTimeInterval:dayTimeInterval sinceDate:[NSDate standardizedToday]] autorelease];
}

+ (NSDate *)startOfWeekDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDate *beginningOfWeek = nil;
	[[NSDate currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek interval:NULL forDate:aDate];
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:beginningOfWeek];
	[comps setHour:standardizedHour];

	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfMonthDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setDay:1];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfYearDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}

	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setMonth:1];
	[comps setDay:1];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)startOfPreviousYearDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}
    
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setYear:[comps year] - 1];
	[comps setMonth:1];
	[comps setDay:1];
	[comps setHour:standardizedHour];
	return [[NSDate currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)endOfWeekDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}
    
    NSRange weekRange = [[NSDate currentCalendar] maximumRangeOfUnit:NSWeekdayCalendarUnit];
    return [[self startOfWeekDate:aDate] dateByAddingDays:weekRange.length - 1];
}

+ (NSDate *)endOfMonthDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}
    
    NSRange monthRange = [[NSDate currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDate];
    return [[self startOfMonthDate:aDate] dateByAddingDays:monthRange.length - 1];
}

+ (NSDate *)endOfYearDate:(NSDate *)aDate
{
	if (aDate == nil) {
		return nil;
	}
    
	NSDateComponents *comps = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:aDate];
	[comps setMonth:[[NSDate currentCalendar] maximumRangeOfUnit:NSMonthCalendarUnit].length];
	[comps setDay:1];
	[comps setHour:standardizedHour];
    NSDate *firstDayOfLastMonth = [[NSDate currentCalendar] dateFromComponents:comps];
    
    NSRange monthRange = [[NSDate currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDayOfLastMonth];
    return [firstDayOfLastMonth dateByAddingDays:monthRange.length - 1];
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
	return [[[NSDate alloc] initWithTimeInterval:(NSTimeInterval)days * dayTimeInterval sinceDate:self]  autorelease];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks
{
	return [self dateByAddingDays:(weeks * 7)];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:months];
	NSDate *date = [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
	[comps release], comps = nil;
	return date;
}

- (NSDate *)dateByAddingYears:(NSInteger)years
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:years];
	NSDate *date = [[NSDate currentCalendar] dateByAddingComponents:comps toDate:self options:0];
	[comps release], comps = nil;
	return date;
}

- (BOOL)isToday
{
	NSDate *today = [[NSDate alloc] init];
	NSDateComponents *todayComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];

	[today release], today = nil;

	NSDateComponents *selfComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];

	return [todayComponents year] == [selfComponents year] && [todayComponents month] == [selfComponents month] && [todayComponents day] == [selfComponents day];
}

- (BOOL)isYesterday
{
	NSDate *yesterday = [NSDate standardizedYesterday];
	NSDateComponents *yesterdayComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:yesterday];

	NSDateComponents *selfComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];

	return [yesterdayComponents year] == [selfComponents year] && [yesterdayComponents month] == [selfComponents month] && [yesterdayComponents day] == [selfComponents day];
}

- (BOOL)isTomorrow
{
	NSDate *tomorrow = [NSDate standardizedTomorrow];
	NSDateComponents *tomorrowComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:tomorrow];

	NSDateComponents *selfComponents = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];

	return [tomorrowComponents year] == [selfComponents year] && [tomorrowComponents month] == [selfComponents month] && [tomorrowComponents day] == [selfComponents day];
}

- (NSInteger)timeIntervalInDaysSinceDate:(NSDate *)referenceDate
{
	NSDate *standardizedSelf = [NSDate standardizedDate:self];
	NSDate *standardizedReferenceDate = [NSDate standardizedDate:referenceDate];

	return (NSInteger)([standardizedSelf timeIntervalSinceDate:standardizedReferenceDate] / dayTimeInterval);
}

@end
