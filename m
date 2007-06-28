Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 16:35:48 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SNZftL018358
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 16:35:43 -0700
Subject: Re: project quotas fstab
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <4683CD56.9000102@fintan.ch>
References: <4683CD56.9000102@fintan.ch>
Content-Type: text/plain
Date: Fri, 29 Jun 2007 09:34:41 +1000
Message-Id: <1183073681.15488.131.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: IT Fintan <it@fintan.ch>
Cc: xfs@oss.sgi.com

On Thu, 2007-06-28 at 17:01 +0200, IT Fintan wrote:
> hi all,
> 
> question : how to load the project quotas directly in fstab ?
> there isnt a documentation! just for group or userquotas.

The mount options are described in Documentation/filesystems/xfs.txt
(in the kernel source), the mount(8) man page is probably out of date
in this area.

cheers.

--
Nathan
