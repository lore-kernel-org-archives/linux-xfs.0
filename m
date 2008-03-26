Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Mar 2008 13:14:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2QKDlpS030396
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 13:13:53 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37DBC103F796
	for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 13:14:21 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id hh2aK4iuoGH8lwt6 for <xfs@oss.sgi.com>; Wed, 26 Mar 2008 13:14:21 -0700 (PDT)
Date: Wed, 26 Mar 2008 21:13:33 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Serious XFS crash
Message-ID: <20080326211333.21d2c7bb@galadriel.home>
In-Reply-To: <20080325233611.GW103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home>
	<20080325233611.GW103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Le Wed, 26 Mar 2008 10:36:11 +1100 vous écriviez:

> Oh, that's toast. Something has overwritten the start of the
> filesystem and it does not appear to be other metadata.  Well, not
> exactly the start of the filesystem - the superblock is untouched.

Just to get sure... Is there the slightest chance than tweaking around
the system can save a couple more files, or is it dead once and for all?

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
