Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C9E2o9197959 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 04:14:02 -0500
Received: from opera.rednote.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62E641BCEF6A
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 02:14:23 -0700 (PDT)
Received: from opera.rednote.net (opera.rednote.net [75.125.207.2]) by
	cuda.sgi.com with ESMTP id L1pFrNH0yCReChI9 for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2009 02:14:23 -0700 (PDT)
Received: from jdc.jasonjgw.net (localhost6.localdomain6 [IPv6:::1])
	by opera.rednote.net (8.14.3/8.14.3) with ESMTP id n5C9EKv8016139
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 09:14:22 GMT
Received: from jdc.jasonjgw.net (localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.3/8.14.3/Debian-9) with ESMTP id
	n5C9EFb2023872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 19:14:15 +1000
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.3/8.14.3/Submit) id n5C9EFwY023870
	for xfs@oss.sgi.com; Fri, 12 Jun 2009 19:14:15 +1000
Date: Fri, 12 Jun 2009 19:14:15 +1000
From: Jason White <jason@jasonjgw.net>
Subject: Re: grub no longer being maintained? so Suse drops support for XFS
	boot?
Message-ID: <20090612091415.GA23747@jdc.jasonjgw.net>
References: <4A31E0FF.8050400@tlinx.org>
	<921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
	<4A31F7FC.2020508@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A31F7FC.2020508@tlinx.org>
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

Linda Walsh <suse@tlinx.org> wrote:
>
> Re: "Grub supposedly unable to start if /boot is on xfs partition,
>    So, because grub is broken, XFS is no longer supported as    a boot 
> partition by Novell/SuSE. (!)...

I should point out that I had to install it using the grub shell; running
grub-install did not work.

Interestingly, Ubuntu are moving to Grub 2 as their default boot loader, a
precedent which other distributions may follow. (Disclaimer: I read the
announcement, but I'm not a Ubuntu user.)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
