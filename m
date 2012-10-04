Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94CCAoK144356 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 07:12:10 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 1uNhzHAXV7c47xL3 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 05:13:35 -0700 (PDT)
Date: Thu, 4 Oct 2012 14:12:54 +0200
From: David Disseldorp <ddiss@suse.de>
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
Message-ID: <20121004141254.70ae3d01@plati.site>
In-Reply-To: <11246457.6091377.1349236739598.JavaMail.root@redhat.com>
References: <506BB645.1000500@tlinx.org>
	<11246457.6091377.1349236739598.JavaMail.root@redhat.com>
Mime-Version: 1.0
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
To: Nathan Scott <nathans@debian.org>
Cc: xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>

On Tue, 2 Oct 2012 23:58:59 -0400 (EDT)
Nathan Scott <nathans@debian.org> wrote:

> 
> ----- Original Message -----
> > Yeah yeah.. rub it in...
> > At one point suse USED to be good -- they were one of the few that
> > used / supported XFS...
> > 
> 
> Mmm, wasn't trying to pass judgement there - I'm sure the OpenSuSE
> package maintainer will take a patch to enable it in the spec file
> there if its not in place.

Thanks Nathan. A bug has been raised to track this:

https://bugzilla.novell.com/show_bug.cgi?id=783510

Cheers, David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
