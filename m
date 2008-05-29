Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 03:28:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TASWnm023502
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:28:32 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D5AF1CA4E3
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:29:24 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id D94twDmS2fZEobjn for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:29:24 -0700 (PDT)
Date: Thu, 29 May 2008 12:29:25 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: free space problem
Message-ID: <20080529122925.159ddb34@harpe.intellique.com>
In-Reply-To: <20080529102107.73D6D1CA6D0@cuda.sgi.com>
References: <20080331093951.100ec125@galadriel.home>
	<20080529102107.73D6D1CA6D0@cuda.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-1?Q?Husz=E1r?= Viktor =?ISO-8859-1?Q?D=E9nes?= <hvd@dwo.hu>
Cc: xfs@oss.sgi.com

Le Thu, 29 May 2008 12:20:49 +0200
Huszár Viktor Dénes <hvd@dwo.hu> écrivait:

> So the question is: how can we increase the icount without formatting
> the partition?

Is it mounted with the inode64 option? 

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
