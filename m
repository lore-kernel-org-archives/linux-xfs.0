Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 17:54:30 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m281s7E5019951
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 17:54:09 -0800
Date: Sat, 8 Mar 2008 02:54:26 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
Message-ID: <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, 8 Mar 2008, Christian Kujau wrote:
> I have 7 processes in D state so far:

FWIW, it's 100% reproducible with 2.6.25-rc3 too...sigh :-\
So, the last working kernel for me is 2.6.24.1 - that's a lot of bisecting 
and I fear that compile errors will invalidate the bisecting results again 
or make it impossible at all....I'll try anyway....tomorrow...

C.
-- 
BOFH excuse #285:

Telecommunications is upgrading.
