Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 11:58:32 -0700 (PDT)
Received: from postfix2-g20.free.fr (postfix2-g20.free.fr [212.27.60.43])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA1IwO21023920
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 11:58:25 -0700
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix2-g20.free.fr (Postfix) with ESMTP id E92D11D7F582
	for <xfs@oss.sgi.com>; Thu,  1 Nov 2007 17:57:30 +0100 (CET)
Date: Thu, 1 Nov 2007 19:58:12 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: 2.6TB Storage Size Problem
Message-ID: <20071101195812.7355aa92@galadriel.home>
In-Reply-To: <alpine.LRH.0.9999.0710302328250.29151@hogwarts.egr.duke.edu>
References: <13501909.post@talk.nabble.com>
	<alpine.LRH.0.9999.0710302328250.29151@hogwarts.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: "paul.lkw" <paul.lkw@mfun.org>, xfs@oss.sgi.com

Le Tue, 30 Oct 2007 23:30:04 -0400 (EDT) vous écriviez:

> 3) You can't boot from such a device (as neither grub nor lilo
> support gpt disklabels).

lilo does support booting from gpt on Debian since Sarge at least. I'd
be surprised if the CentOS build doesn't.

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
