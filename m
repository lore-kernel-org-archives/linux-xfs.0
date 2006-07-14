Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Jul 2006 22:36:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6E5aADW002276
	for <xfs@oss.sgi.com>; Thu, 13 Jul 2006 22:36:11 -0700
Message-ID: <44B71DB1.3040801@sandeen.net>
Date: Thu, 13 Jul 2006 23:29:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: dmapi support for xfs on fedora core 5?
References: <20060713212404.60071.qmail@web35705.mail.mud.yahoo.com>
In-Reply-To: <20060713212404.60071.qmail@web35705.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Hardy <linuxrlz@yahoo.com>
Cc: xfs@oss.sgi.com

Jeff Hardy wrote:
> Hello, is there any quick howto on how to setup dmapi
> support on the xfs on fc5? I have mounted xfs with no
> problem, but running a program calling dm_init_service
> fails. I can't seem to find any references to how to
> setup dmapi support.

I don't think dmapi kernel support is in fc5....  you'd probably need to start 
w/ the cvs kernel from oss.sgi.com, or suse (or a custom fc5 kernel....)

-Eric
