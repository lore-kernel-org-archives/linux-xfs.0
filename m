Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 May 2008 03:42:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m42AgNLD031283
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 03:42:24 -0700
Received: from outbound9-dub-R.bigfish.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DBCEADE4D1
	for <xfs@oss.sgi.com>; Fri,  2 May 2008 03:43:07 -0700 (PDT)
Received: from outbound9-dub-R.bigfish.com (outbound-dub.frontbridge.com [213.199.154.16]) by cuda.sgi.com with ESMTP id U3Ehdi135iisQ6Wf for <xfs@oss.sgi.com>; Fri, 02 May 2008 03:43:07 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: query
content-class: urn:content-classes:message
Date: Fri, 2 May 2008 16:12:58 +0530
Message-ID: <87604E51C77C4F4988CF1C7F088D562D38BE0A@in02ex01.int.cgg.com>
From: "Nandedkar, Rishiraj" <Rishiraj.Nandedkar@cggveritas.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Hi,

Thank you for update but Linux 7.3 means red hat 7 update 3 red hat 3 update 5.In our system we are unable to detect disk which is having file system in XFS format. Our system is not able to support it. 2.4.21-32.EL is kenal version on our systems. Please let me know which version should I use in redhat.I am trying this with fedora core 3

Thx 
rishi



-----Original Message-----
From: Emmanuel Florac [mailto:eflorac@intellique.com] 
Sent: Friday, May 02, 2008 4:06 PM
To: Nandedkar, Rishiraj
Cc: xfs@oss.sgi.com
Subject: Re: query

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
