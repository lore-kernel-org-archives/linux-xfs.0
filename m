Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q170m5Rc179244
	for <linux-xfs@oss.sgi.com>; Mon, 6 Feb 2012 18:48:06 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 0Mc8t4eALdOA3q4P for <linux-xfs@oss.sgi.com>;
	Sat, 04 Feb 2012 16:47:09 -0800 (PST)
References: <4F2CB162.7090700@clear.net.nz>
	<loom.20120204T152354-163@post.gmane.org>
In-Reply-To: <loom.20120204T152354-163@post.gmane.org>
Mime-Version: 1.0 (1.0)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Placing the root partition on an XFS filesystem is not supported
Date: Sat, 4 Feb 2012 18:47:05 -0600
Message-Id: <20120207004805.79CBDA42060@cuda.sgi.com>
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
To: Marcos Mello <marcosfrm@gmail.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

On Feb 4, 2012, at 8:29 AM, Marcos Mello <marcosfrm@gmail.com> wrote:

> Richard Scobie <r.scobie <at> clear.net.nz> writes:
> 
>> 
>> Eric Sandeen wrote:
>> 
>>> F16 prevents it?  I didn't see it in the upstream tree.  That should
>>> not be so.  :/
>> 
>> Indeed not. I completed an F16 install 4 days ago, using XFS as the / 
>> filesystem.
>> 
> 
> :-| Well, I'm amlost sure I got the same message when intalling F16 minimal ISO
> last week. Will try again, maybe was just a confusion from my part.
> 
Note, the livecd cannot do an xfs install because it just transfers the (ext4) livecd root to the hard drive.  The non-livecd installer should work though.

-Eric

> Thanks,
> 
> Marcos
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
