Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 11:39:53 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1LJdm4m022209
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 11:39:49 -0800
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE550E8AD20
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 11:40:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id 92KoI1QHWj0EDYVj for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 11:40:13 -0800 (PST)
Message-ID: <47BDD390.1040102@sandeen.net>
Date: Thu, 21 Feb 2008 13:40:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on Red Hat EL5
References: <00fa01c874b5$1908d150$8e0010ac@sg.lcl> <alpine.DEB.1.00.0802211401590.17484@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.00.0802211401590.17484@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Miakell Figueredo <figueredom@scoregroup.com>, xfs@oss.sgi.com

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
