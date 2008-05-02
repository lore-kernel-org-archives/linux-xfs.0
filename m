Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 May 2008 05:04:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m42C4Rxn009837
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 05:04:30 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C93D71622700
	for <xfs@oss.sgi.com>; Fri,  2 May 2008 05:05:11 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id vQXS9zAK1HJWPqBG for <xfs@oss.sgi.com>; Fri, 02 May 2008 05:05:11 -0700 (PDT)
Date: Fri, 2 May 2008 14:05:09 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: query
Message-ID: <20080502140509.62dadf26@harpe.intellique.com>
In-Reply-To: <87604E51C77C4F4988CF1C7F088D562D38BE0A@in02ex01.int.cgg.com>
References: <87604E51C77C4F4988CF1C7F088D562D38BE0A@in02ex01.int.cgg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Nandedkar, Rishiraj" <Rishiraj.Nandedkar@cggveritas.com>
Cc: xfs@oss.sgi.com

Le Fri, 2 May 2008 16:12:58 +0530
"Nandedkar, Rishiraj" <Rishiraj.Nandedkar@cggveritas.com> écrivait:

> Thank you for update but Linux 7.3 means red hat 7 update 3 red hat 3
> update 5.In our system we are unable to detect disk which is having
> file system in XFS format. Our system is not able to support it.
> 2.4.21-32.EL is kenal version on our systems. Please let me know
> which version should I use in redhat.I am trying this with fedora
> core 3

RedHat 7.3 ( or even 8.0 and 9.0 for that matter) are really very old
and outdated. You'd be much better for pretty much everything with
something more up-to-date. Back then RedHat 7.x needed a special
additional CD provided by SGI for XFS support IIRC.
I'm pretty surprised that RHEL 3 doesn't support XFS though. Anyway,
RHEL 4 and 5 do without any doubt (I use XFS on them).

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
