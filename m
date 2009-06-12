Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CAFs1U199843 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 05:15:54 -0500
Received: from opera.rednote.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDEB31BCF2AD
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 03:16:15 -0700 (PDT)
Received: from opera.rednote.net (opera.rednote.net [75.125.207.2]) by
	cuda.sgi.com with ESMTP id oxFCUrRfspHeLCBS for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2009 03:16:15 -0700 (PDT)
Received: from jdc.jasonjgw.net (localhost6.localdomain6 [IPv6:::1])
	by opera.rednote.net (8.14.3/8.14.3) with ESMTP id n5CAGCZZ017049
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 10:16:14 GMT
Received: from jdc.jasonjgw.net (localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.3/8.14.3/Debian-9) with ESMTP id
	n5CAG8qU025777
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 20:16:08 +1000
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.3/8.14.3/Submit) id n5CAG8YE025775
	for xfs@oss.sgi.com; Fri, 12 Jun 2009 20:16:08 +1000
Date: Fri, 12 Jun 2009 20:16:08 +1000
From: Jason White <jason@jasonjgw.net>
Subject: Re: grub no longer being maintained? so Suse drops support for XFS
	boot?
Message-ID: <20090612101608.GA25623@jdc.jasonjgw.net>
References: <4A31E0FF.8050400@tlinx.org>
	<921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
	<4A31F7FC.2020508@tlinx.org> <20090612092825.GA16974@citd.de>
	<4A322377.5020403@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A322377.5020403@dermichi.com>
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
To: xfs@oss.sgi.com

Michael Weissenbacher <mw@dermichi.com> wrote:
> I've always been using a small seperate ext2 Partition for /boot, since i've
> found this to be the most robust solution. Also when other Filesystems like
> reiser4 or btrfs come in play. I'd say XFS support in Grub is nice to have,
> but not a must.  

I would much prefer to have that support, since I tend to partition my disks
as one single XFS partition, which can be backed up with xfsdump easily.

If anyone has run tests with Grub2 in its current state of development, I
would be interested in the results.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
