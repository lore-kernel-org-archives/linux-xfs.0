Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 May 2008 03:35:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m42AYtmb030501
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 03:34:57 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8C04ADE326
	for <xfs@oss.sgi.com>; Fri,  2 May 2008 03:35:39 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id l6jE6Y6Cp8wBRDIY for <xfs@oss.sgi.com>; Fri, 02 May 2008 03:35:39 -0700 (PDT)
Date: Fri, 2 May 2008 12:35:41 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: query
Message-ID: <20080502123541.2216848e@harpe.intellique.com>
In-Reply-To: <87604E51C77C4F4988CF1C7F088D562D9BE614@in02ex01.int.cgg.com>
References: <87604E51C77C4F4988CF1C7F088D562D9BE614@in02ex01.int.cgg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Nandedkar, Rishiraj" <Rishiraj.Nandedkar@cggveritas.com>
Cc: xfs@oss.sgi.com

Le Fri, 2 May 2008 15:38:13 +0530
"Nandedkar, Rishiraj" <Rishiraj.Nandedkar@cggveritas.com> écrivait:

> I would like to know which Linux version support XFS file system. I am
> working on linux3.5 and 4.3 and 7.3 but all these versions not support
> XFS.

You are misleaded. There is no such thing as "linux 3.5" or "linux
7.3". Current Linux kernel version is 2.6.25. However there exists
hundreds of GNU/Linux distributions, with many different numbering
schemes, that may come with or without XFS support.

Some current common distributions : Debian GNU/Linux 4.0, SuSE Linux
Enterprise Server 10.0, RedHat Enterprise Linux 5.0...
See http://distrowatch.com/ to find about most of them.

Most distributions (except RedHat Enterprise and SuSE Enterprise) may
be downloaded (and used) for free. Don't stick with an outdated one!

As far as I know, all distributions less than 5 years old should
support XFS natively. So either you use some very old distribution
(like RedHat Linux 7.3, which is antique), or you didn't looked for the
right thing at the right place.


-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
