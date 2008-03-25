Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 12:05:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PJ4ueS016168
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 12:04:58 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B20712085C9
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 12:05:11 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id p4E69j5OGqNaYCLl for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 12:05:11 -0700 (PDT)
Date: Tue, 25 Mar 2008 20:03:39 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Serious XFS crash
Message-ID: <20080325200339.1293a5e6@galadriel.home>
In-Reply-To: <47E9494D.8080807@sandeen.net>
References: <20080325185453.3a1957dd@galadriel.home>
	<47E9494D.8080807@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Le Tue, 25 Mar 2008 13:49:49 -0500 vous écriviez:

> Out of curiosity, what was the storage setup for that 8T volume?  (md
> I guess, but what was behind it?)
> 

Actually 2 hardware RAID-5 volumes ( 3Ware 9550SX) aggregated thru a
software RAID-0 (md).

> Also what architecture was this?

Plain ole stinkin' x86, 2x dual core Xeon HT ( 8 cores ). Never lost
any data on my MIPS/IRIX systems. 

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
