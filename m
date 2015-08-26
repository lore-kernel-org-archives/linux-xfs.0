Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DCAD7F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 14:04:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D8A9304043
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 12:04:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Dm1336kULtBCt53r for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 12:04:52 -0700 (PDT)
Message-ID: <55DE0DD3.90108@sandeen.net>
Date: Wed, 26 Aug 2015 14:04:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>	<55DCE1CF.5030708@sandeen.net>	<CABppvi6W5_1GBrb8x1wOAq3X6yraTtt1UYEFE+dBzcXj3yTzrg@mail.gmail.com>	<20150825234300.GN714@dastard>
	<CABppvi7AYbqiskyrEp3As6RPyRz0pThoqVEcjX4736KV-wLkCA@mail.gmail.com>
In-Reply-To: <CABppvi7AYbqiskyrEp3As6RPyRz0pThoqVEcjX4736KV-wLkCA@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 8/26/15 12:48 PM, Shrinand Javadekar wrote:
>>>>> >> >> Any ideas why this might be happening?
>>>> >> >
>>>> >> > With the paucity of information you've provided, nope!
>>> >>
>>> >> Apologies. What more information can I provide?
>> >
>> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> [Shri] I mentioned this in my first email. Here's the information:
> http://oss.sgi.com/archives/xfs/2015-06/msg00108.html

Just as an aside:

A 3 month old email under a different subject doesn't really help
us in this thread.  ;)

You're the only one who knows if this is the same machine, whether you've
upgraded since, etc.  So we had to ask...

For anyone reading: 

If you're having a problem, please, please always start with as much information
about your environment as you can provide, as described in the xfs.org URL
above.  It saves many email round-trips, and helps us help you better.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
