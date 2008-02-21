Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 11:42:46 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1LJgZfv022616
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 11:42:41 -0800
Received: from mx1.scoregroup.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EB816024CF
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 11:43:00 -0800 (PST)
Received: from mx1.scoregroup.com (mx1.scoregroup.com [67.151.115.140]) by cuda.sgi.com with ESMTP id 1BTGDx37cXM6HuAi for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 11:43:00 -0800 (PST)
From: "Miakell Figueredo" <figueredom@scoregroup.com>
References: <00fa01c874b5$1908d150$8e0010ac@sg.lcl> <alpine.DEB.1.00.0802211401590.17484@p34.internal.lan> <47BDD390.1040102@sandeen.net>
Subject: RE: XFS on Red Hat EL5
Date: Thu, 21 Feb 2008 14:43:19 -0500
Message-ID: <010301c874c2$02c80700$8e0010ac@sg.lcl>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <47BDD390.1040102@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Eric Sandeen' <sandeen@sandeen.net>, 'Justin Piszcz' <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Great! Thank you. I will attempt to install and mount our 10TB unit.

Thanks, Again!
Miakell

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: Thursday, February 21, 2008 2:40 PM
To: Justin Piszcz
Cc: Miakell Figueredo; xfs@oss.sgi.com
Subject: Re: XFS on Red Hat EL5

Justin Piszcz wrote:
> Eric makes some RPMs for them..

Yep, take a look at http://sandeen.net/rhel5_xfs

They're a bit outdated at this point, though I'm not aware of any
significant bugs.

Or, the centos distro has similar (if not the same) rpms.

RHEL does not support xfs, so using xfs may change whatever support
agreements you have in place.

-Eric (speaking only for himself)

> On Thu, 21 Feb 2008, Miakell Figueredo wrote:
> 
>> Hello:
>>
>>
>>
>> Is there an RPM for XFS on Red Hat? Currently we are running
>> "2.6.18-53.1.13.el5xen #1 SMP Mon Feb 11 13:41:50 EST 2008 x86_64 x86_64
>> x86_64 GNU/Linux" and installed "xfsprogs.i386-2.9.5-1.fc9" and I cannot
>> mount the volume.
