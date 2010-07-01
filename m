Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6103wZX156031 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 19:03:58 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E502341DF6E
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 17:06:44 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id NCEBrI01LII3yB5o for
	<xfs@oss.sgi.com>; Wed, 30 Jun 2010 17:06:44 -0700 (PDT)
Message-ID: <4C2BDBFE.5050007@tlinx.org>
Date: Wed, 30 Jun 2010 17:06:22 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs_restore -R -- recovering a previous restore...does it work?
References: <4C2B37D6.50801@tlinx.org> <4C2B6EEE.5050103@tlinx.org>
	<20100630172750.GA20764@puku.stupidest.org>
	<4C2B8440.5030503@tlinx.org>
	<20100630182755.GA23188@puku.stupidest.org>
	<4C2B96AC.4030009@tlinx.org>
	<20100630213653.GA26145@puku.stupidest.org>
In-Reply-To: <20100630213653.GA26145@puku.stupidest.org>
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
To: Chris Wedgwood <cw@f00f.org>, xfs-oss <xfs@oss.sgi.com>

Chris Wedgwood wrote:
>>> how large is the image to be restored?
>> ( 2.15TB)

> out of interest, so smaller images work?


I don't know...this was my first time I ever tried it.

Usually smaller images don't have so many opportunities to get interrupted. :-)

This one took 3h 18m, .. a crappy 189MB/s!

I was just unlucky enough to have something interrupt it 3 times in a row
(since it was the partition that was corrupt -- I'm a bit scattered as I have
no idea what might have caused that partition to go corrupt and no idea
if it is just going turn around and happen again.  Unfortunately, it's not
like it is the easiest partition to backup & restore.

Guess I can experiment! ;-)




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
