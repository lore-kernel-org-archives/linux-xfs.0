Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Nov 2006 09:45:38 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kADHjUaG005239
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 09:45:31 -0800
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38DCA51C4BB
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 09:44:41 -0800 (PST)
Message-ID: <4558AEFE.10108@sandeen.net>
Date: Mon, 13 Nov 2006 11:44:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Update for the RHEL4 XFS module?
References: <455893BE.4010208@moving-picture.com> <45589A06.7040503@sandeen.net> <4558AE11.2030108@falconstor.com>
In-Reply-To: <4558AE11.2030108@falconstor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: geir.myrestrand@falconstor.com
Cc: James Pearson <james-p@moving-picture.com>, xfs@oss.sgi.com

Geir A. Myrestrand wrote:
> Eric Sandeen wrote:
>> James Pearson wrote:
>>> The RHEL4 XFS module code at 
>>> <ftp://oss.sgi.com/projects/xfs/testing/RHEL4/> is now about a year old.
>>>
>>> Is there any chance that it could be updated with something based on 
>>> more recent code?
>>>
>> Funny you should ask, I just started looking at this last night :)
>>
>> It was originally based on the SLES9 xfs code; my plan is to simply 
>> update it to the latest sles9 xfs codebase, as that has been tended to 
>> with a goal of stability by the fine folks at sgi....  so, no 
>> bleeding-edge xfs for now (I don't particularly want to backport 2.6.18 
>> xfs code to 2.6.9....)
>>
> 
> Eric, please notify us via the list when it has been updated.
> I would like this module updated too...

Will do.  Are there particular issues you're having, or is your code
just feeling a bit old in general.  ;-)

-Eric
