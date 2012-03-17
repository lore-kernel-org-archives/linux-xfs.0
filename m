Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2H4LrPC235273 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 23:21:53 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 9RSm48n47Y9AxDDi
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 21:21:51 -0700 (PDT)
Message-ID: <4F64115D.50208@hardwarefreak.com>
Date: Fri, 16 Mar 2012 23:21:49 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: NOW:Peter goading Dave over delaylog -  WAS: Re: raid10n2/xfs setup
	guidance on write-cache/barrier
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
In-Reply-To: <20321.63389.586851.689070@tree.ty.sabi.co.UK>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 3/15/2012 9:07 AM, Peter Grandi wrote:
>>>> I want to create a raid10,n2 using 3 1TB SATA drives.
>>>> I want to create an xfs filesystem on top of it. The
>>>> filesystem will be used as NFS/Samba storage.
> 
> Consider also an 'o2' layout (it is probably the same thing for a
> 3 drive RAID10) or even a RAID5, as 3 drives and this usage seems
> one of the few cases where RAID5 may be plausible.

It's customary to note in your message body when you decide to CC
another mailing list, and why.  I just got to my XFS folder and realized
you'd silently CC'd XFS.  This was unnecessary and simply added noise to
XFS.  Given some of your comments in this post I suspect you did so in
an effort to goad Dave into some kind of argument WRT delayed logging
performance, and his linux.conf.au presentation claims in general.
Doing this via subterfuge simply reduces people's level of respect for
you Peter.

If you want to have the delayed logging performance discussion/argument
with Dave, it should be its own thread on xfs@oss, not slipped into a
thread started on another list and CC'ed here.  I'm removing linux-raid
from the CC list of this message, as anything further in this discussion
topic is only relevant to XFS.

I'm guessing either Dave chose not to take your bait, or simply didn't
read your message.  If the former this thread will likely die now.  If
the latter, and Dave decides to respond, I'm grabbing some popcorn, a
beer, and a lawn chair. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
