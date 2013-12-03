Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DD8E7F50
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 07:35:46 -0600 (CST)
Received: from xmail.sgi.com (pv-excas2-dc21.corp.sgi.com [137.38.106.9])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C7CC30407E
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 05:35:43 -0800 (PST)
Message-ID: <529DDE2D.3000501@sgi.com>
Date: Tue, 3 Dec 2013 07:35:41 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: stop special casing nfs and udf
References: <20131107204635.GA22954@infradead.org>	<20131122091553.GA32568@infradead.org>	<20131202174045.GA21861@infradead.org>	<20131202232549.GV8803@dastard>
	<20131202233629.GM1935@sgi.com> <20131203042936.GY8803@dastard>
In-Reply-To: <20131203042936.GY8803@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 12/02/2013 10:29 PM, Dave Chinner wrote:
> On Mon, Dec 02, 2013 at 05:36:30PM -0600, Ben Myers wrote:
>> On Tue, Dec 03, 2013 at 10:25:49AM +1100, Dave Chinner wrote:
>>> On Mon, Dec 02, 2013 at 09:40:45AM -0800, Christoph Hellwig wrote:
>>>> On Fri, Nov 22, 2013 at 01:15:53AM -0800, Christoph Hellwig wrote:
>>>>> ping?
>>>>
>>>> ping^2?
>>>
>>> I just got write access to the XFS git repos on oss.sgi.com, so I'll
>>> start hoovering up all the outstanding xfstests patches as a
>>> shakedown pass before I touch anything else...
>>
>> You might want to chat with Rich.  There may be some already in progress.
>
> I've already pushed the ones I found last week on the list.
>
Thanks for doing this.

> FYI, I've been waiting for repo write perms to be able to push them
> since wednesday last week. Rich hasn't said anything on the mailing
> list or on IRC in that time, so I can only conclude that he's off
> doing something else.
>
> Handling xfstests patches in a manner necessary for upstream commit
> is something I've already integrated into my day-to-day workflow. As
> such, I'm able to push reviewed patches at almost any time (within
> reason - next day is best for everyone) at almost zero cost to me.
> That cost will go down as I script and optimise my workflow.
>
> If other developers don't want me to do this, let them speak up.
>
> However, as a maintainer, I'm not happy with leaving reviewed
> patches on the list for weeks before commiting them. As a developer,
> there is nothing more frsutrating that having to continually remind
> the maintainer that they need to commit a patch.
>
> Hence if a developer sends a ping to remind the maintainers about a
> reviewed patch that has been sitting around, then I'm going to do
> something about it straight away...
My apologies to Christoph. I missed that I thought he was waiting for a 
review, not a commit from me.
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
