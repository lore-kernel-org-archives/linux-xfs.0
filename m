Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5UHnMB1138852 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 12:49:22 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 681EE14B3C25
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 10:57:04 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id RXuebcyXp6TlI9bz for
	<xfs@oss.sgi.com>; Wed, 30 Jun 2010 10:57:04 -0700 (PDT)
Message-ID: <4C2B8440.5030503@tlinx.org>
Date: Wed, 30 Jun 2010 10:52:00 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs_restore -R -- recovering a previous restore...does it work?
References: <4C2B37D6.50801@tlinx.org> <4C2B6EEE.5050103@tlinx.org>
	<20100630172750.GA20764@puku.stupidest.org>
In-Reply-To: <20100630172750.GA20764@puku.stupidest.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Dmesg shows nothing revealing.

I am not using tape -- I'm restoring from a file.

Does it only work with tapes?  I didn't recall it saying so.

-l

Chris Wedgwood wrote:
> On Wed, Jun 30, 2010 at 09:21:02AM -0700, Linda A. Walsh wrote:
> 
>> I just had it happen again -- something killed off the window it was
>> executing in -- system didn't go down, but it got a hangup -- a
>> cleaner shutdown -- but it still doesn't recover.
> 
> dmesg ...
> 
> see anything?
> 
>> Under what circumstances should this work?  Or does it work?
> 
> it used to work for me, i've not tried it recently though, i basically
> gave up tapes (and xfsdump/restore) some time back due to size/cost
> contraints

----
Do you not keep backups at all anymore?  Or if you do, do you not 
care about the metastuff?  

Only other backup util, that I know of, that speaks meta, is 'star'.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
