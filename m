Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 May 2008 05:24:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m42CODNB011222
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 05:24:14 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 908CE162202F
	for <xfs@oss.sgi.com>; Fri,  2 May 2008 05:24:56 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id dAK8EQh9ApFalQ62 for <xfs@oss.sgi.com>; Fri, 02 May 2008 05:24:56 -0700 (PDT)
Date: Fri, 2 May 2008 14:25:00 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: query
Message-ID: <20080502142500.049e14b0@harpe.intellique.com>
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

> In our system we are unable to detect disk which is having file
> system in XFS format. Our system is not able to support it.

Just to get sure, how did you try to mount the XFS disks? Is there a
software RAID, LVM or other additional layer that may prevent an older
system to mount a volume made on a newer one?

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
