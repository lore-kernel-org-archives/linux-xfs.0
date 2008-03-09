Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 09:44:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m29GiMrG003504
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 09:44:27 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB2F6676D74
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2008 09:44:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id g53wLb2Av486Dcs4 for <xfs@oss.sgi.com>; Sun, 09 Mar 2008 09:44:49 -0700 (PDT)
Message-ID: <47D413FA.50602@sandeen.net>
Date: Sun, 09 Mar 2008 11:44:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.25-rc hangs
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de> <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Christian Kujau wrote:
> On Sat, 8 Mar 2008, Christian Kujau wrote:
>> FWIW, it's 100% reproducible with 2.6.25-rc3 too...sigh :-\
>> So, the last working kernel for me is 2.6.24.1 - that's a lot of bisecting 
>> and I fear that compile errors will invalidate the bisecting results again or 
>> make it impossible at all....I'll try anyway....tomorrow...
> 
> Bisecting failed as expected :-(
> I tried to follow the git-bisect manpage (and have successfully used 
> bisect in the past a few times), but I think ~5700 revisions between 
> 2.6.24 and 2.6.25 are just too much fuzz. The bisect logs so far, with
> my comments inbetween:

Christian, what is the test you are using for the bisect?

Thanks,
-Eric
