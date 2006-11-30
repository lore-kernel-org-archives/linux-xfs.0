Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 21:12:07 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAU5BqaG013292
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 21:11:53 -0800
Message-ID: <456E67EB.2030008@sandeen.net>
Date: Wed, 29 Nov 2006 23:11:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: inode64 workaround
References: <200611290027.AA04740@TNESG9305.tnes.nec.co.jp> <1164838985.4992.30.camel@edge> <456E1B08.7090802@delusion.com> <456E2A30.4010101@melbourne.sgi.com> <456E2D0E.2000007@delusion.com> <456E30A5.6080109@melbourne.sgi.com> <456E35CA.2000601@delusion.com>
In-Reply-To: <456E35CA.2000601@delusion.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Deanan <delusion@delusion.com>
Cc: chatz@melbourne.sgi.com, xfs@oss.sgi.com

Deanan wrote:
> Thanks. Unfortunately 2.6.9 doesn't have it. :(

Is this rhel4?

You could probably pretty easily add the inode rotor code into the xfs 
modules that you're using, if that's the case.

-Eric

>> This is a sysctl, see sysctl(8).
>>
>> It was introduced to XFS in October 2004, I'm not sure if it made 2.6.9.
>>
>> If this doesn't help a little then I'm unsure why you think that 
>> inode64 is
>> going to solve your problem?
>>
>> David
>>   
> 
> 
