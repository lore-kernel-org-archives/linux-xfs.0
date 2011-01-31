Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0VISk8O119747 for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 12:28:46 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0F3A29FD04
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 10:31:13 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id EhqEL4pIvmESCDig
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 10:31:13 -0800 (PST)
Message-ID: <4D46FFF0.5090405@hardwarefreak.com>
Date: Mon, 31 Jan 2011 12:31:12 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs Digest, Vol 29, Issue 102
References: <mailman.1364.1296445754.4020.xfs@oss.sgi.com>
	<SNT130-w323D725C89EB3F13E94A3BDAE20@phx.gbl>
In-Reply-To: <SNT130-w323D725C89EB3F13E94A3BDAE20@phx.gbl>
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
To: lord worm <cryptopsy@live.com>
Cc: xfs@oss.sgi.com

lord worm put forth on 1/30/2011 10:41 PM:

> Stan, do you check dates on links before you paste them here? I don't care if its the 1st results of the google search 'meaning of life', its irrelevant and oudated.

At the time I sent that reply, you had posted no log information, nothing
concrete to allow us to focus our troubleshooting efforts.  At that time, the
information in the link I provided could have been as relevant as any other.  At
that time I had not seen the off list back-n-forth between you and Dave that
contained a little bit more information from you.  Note that I said "might be
relevant", not "this is your answer".

Note that Dave recently pointed an OP to a 1996 XFS paper.  Some information in
that 15 year old paper is still relevant today.  You cannot simply discard
information because it appears "old" to you.  Some aspects of XFS haven't
changed in 16 years.

As I said in my first response, xfsdump/xfsrestore would have avoided your
current problem, as well as xfs_copy, as Dave pointed out.

There is nothing set in stone that prevents dd from working with XFS
filesystems.  However, it is obviously less forgiving of error, user or
otherwise, than the 'equivalent' XFS utilities.

Lastly, getting testy with those attempting to assist you isn't going to further
your efforts in fixing your problem.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
