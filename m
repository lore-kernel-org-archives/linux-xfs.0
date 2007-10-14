Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Oct 2007 05:21:49 -0700 (PDT)
Received: from frodo.openenterprise.co.uk (ns1.openenterprise.co.uk [81.21.68.157])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9ECLa9M029237
	for <xfs@oss.sgi.com>; Sun, 14 Oct 2007 05:21:41 -0700
Message-ID: <471209D0.9090305@openenterprise.co.uk>
Date: Sun, 14 Oct 2007 13:21:36 +0100
From: Nick Gregory <nick@openenterprise.co.uk>
MIME-Version: 1.0
Subject: Re: Repeated XFS Crash on x86_64 fiesty
References: <470F2A1E.9070503@openenterprise.co.uk> <Pine.LNX.4.64.0710121551470.16962@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0710121551470.16962@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Justin Piszcz wrote:
> Have you run memtest86?  Have you checked the CPU?  Is it an AMD64 CPU 
> where the memory controller is onboard (and .. if damaged/overheating) 
> could cause problems with the memory?
> 

Thanks for the suggestions. Shortly after my posting I had a drive fail 
shortly followed by another three taking out 6TB of data :-( , luckily 
part of a replicated pair.

So its certainly a hardware thing either a bad raid card or a bad batch 
of drives rather than anything to do with XFS.
