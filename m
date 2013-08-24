Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08DBA29DFD
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 21:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA4B6304051
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 19:35:33 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id FNAKDZDurUxkbkBs
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 19:35:32 -0700 (PDT)
Message-ID: <52181BF3.5050002@hardwarefreak.com>
Date: Fri, 23 Aug 2013 21:35:31 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Power loss and zero-length files
References: <CAGwuE-p8=UwpGUhgpqkWn4U4jU-KnfC3C19Kqqv7uYLJvubxgQ@mail.gmail.com>
	<20130823152058.GR5262@sgi.com>
	<CAGwuE-q5r51t43SxDryReN1EN-w=YLR9ehtWxbhDeRjw3J9AAA@mail.gmail.com>
	<20130823154534.GM7153@sgi.com>
	<5217E2FA.1030008@hardwarefreak.com>
	<20130823225035.GQ7153@sgi.com>
In-Reply-To: <20130823225035.GQ7153@sgi.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: Robert Widmer <robertwidmer@gmail.com>, xfs@oss.sgi.com

On 8/23/2013 5:50 PM, Ben Myers wrote:
> Hey Stan,
> 
> On Fri, Aug 23, 2013 at 05:32:26PM -0500, Stan Hoeppner wrote:
>> On 8/23/2013 10:45 AM, Ben Myers wrote:
>>> On Fri, Aug 23, 2013 at 11:27:19AM -0400, Robert Widmer wrote:
>>>> On Fri, Aug 23, 2013 at 11:20 AM, Ben Myers <bpm@sgi.com> wrote:
>>
>>>> The person ran the script, unplugged the machine (instead of shutting
>>>> it down like they were told), and boxed it up.
>>>
>>> lol  ;)
>>
>> Yeah, that's pretty ignorant.  Reminds me of this thread in March:
>>
>> http://oss.sgi.com/archives/xfs/2013-03/msg00152.html
>>
>> But "we" (IT industry) shot ourselves in the foot when we began using
>> the word "appliance".  No wonder then that some people literally treat
>> them as such.
> 
> On the other foot, it's probably not such an unreasonable expectation for
> someone coming from a different background to expect that once it *looks* done
> it actually *is* done.
> 
> It's as if you were to take me scuba diving, or drag racing... I have zero
> expertise and I'd probably be doing all the silly ignorant things too.
> 
> Or... maybe the tech was just in a hurry and didn't think all the way through
> the consequences.  I've been there.  ;)

I think the problem in many of these cases is that the people using the
hardware are not technicians, at least in the traditional sense.  So
when 'we' use the word appliance they treat the hardware like a TV or
DVD player.  With either, pulling the plug while it's running has no
detrimental effect.

The SCUBA and drag racing analogies don't really fit here as you're
completely out of your element.  And acquiring the skills to do either
requires many weeks of training, time in the water or behind the wheel.
 "shutdown -h now <ENTER>" requires no training, but just reading one
line on an instruction sheet and typing it in. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
