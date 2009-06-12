Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C9i9cM198873 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 04:44:09 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FBE01AC19E5
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 02:44:30 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[83.64.48.195]) by cuda.sgi.com with ESMTP id j4bEDhGI0E6VxEBJ
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 02:44:30 -0700 (PDT)
Message-ID: <4A322377.5020403@dermichi.com>
Date: Fri, 12 Jun 2009 11:44:23 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: grub no longer being maintained? so Suse drops support for XFS
	boot?
References: <4A31E0FF.8050400@tlinx.org>	<921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>	<4A31F7FC.2020508@tlinx.org>
	<20090612092825.GA16974@citd.de>
In-Reply-To: <20090612092825.GA16974@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Linda Walsh <suse@tlinx.org>, Sujit Karataparambil <sjt.kar@gmail.com>, SuSE Linux <opensuse@opensuse.org>, xfs-oss <xfs@oss.sgi.com>

Hi!
> OTOH as long as you can live with a separate boot-partition, what's the 
> problem of formating it with ext2. fsck-times for a single/double-digit 
> MB boot-partition are negligible.
I've always been using a small seperate ext2 Partition for /boot, since i've found this to be the most robust solution. Also when other Filesystems like reiser4 or btrfs come in play. I'd say XFS support in Grub is nice to have, but not a must.
Maybe the distributions should just default to an ext2 Partition for /boot. That would keep most people happy, wouldn't it?

just my 2c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
