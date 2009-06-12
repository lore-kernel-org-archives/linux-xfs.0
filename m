Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C5nRqW191013 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 00:49:29 -0500
Received: from opera.rednote.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8311D1AC0DBA
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 22:49:40 -0700 (PDT)
Received: from opera.rednote.net (opera.rednote.net [75.125.207.2]) by
	cuda.sgi.com with ESMTP id Pcc59obFWtGmopAv for
	<xfs@oss.sgi.com>; Thu, 11 Jun 2009 22:49:40 -0700 (PDT)
Received: from jdc.jasonjgw.net (localhost6.localdomain6 [IPv6:::1])
	by opera.rednote.net (8.14.3/8.14.3) with ESMTP id n5C5nam7013354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 05:49:39 GMT
Received: from jdc.jasonjgw.net (localhost [IPv6:::1])
	by jdc.jasonjgw.net (8.14.3/8.14.3/Debian-9) with ESMTP id
	n5C5nW76015807
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 15:49:32 +1000
Received: (from jason@localhost)
	by jdc.jasonjgw.net (8.14.3/8.14.3/Submit) id n5C5nWk1015805
	for xfs@oss.sgi.com; Fri, 12 Jun 2009 15:49:32 +1000
Date: Fri, 12 Jun 2009 15:49:32 +1000
From: Jason White <jason@jasonjgw.net>
Subject: Re: grub no longer being maintained? drops support for XFS?
Message-ID: <20090612054932.GA15781@jdc.jasonjgw.net>
References: <4A31E0FF.8050400@tlinx.org>
	<921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
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

Sujit Karataparambil <sjt.kar@gmail.com> wrote:
> This is an Known Issue. Grub hangs when used With XFS. You could
> Try Lilo instead. 

Grub in the master boot record works for me with XFS as the only file system
on the disk. These are Debian machines, in case that makes a difference.

Grub 2 might have better support for XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
