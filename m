Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 May 2008 05:51:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m42Cp51v013295
	for <xfs@oss.sgi.com>; Fri, 2 May 2008 05:51:06 -0700
Received: from proxy2.bredband.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 714E4119CF0
	for <xfs@oss.sgi.com>; Fri,  2 May 2008 05:51:48 -0700 (PDT)
Received: from proxy2.bredband.net (proxy2.bredband.net [195.54.101.72]) by cuda.sgi.com with ESMTP id jbHx7kdeep6mXwed for <xfs@oss.sgi.com>; Fri, 02 May 2008 05:51:48 -0700 (PDT)
Received: from ironport2.bredband.com (195.54.101.122) by proxy2.bredband.net (7.3.127)
        id 4811833300270805 for xfs@oss.sgi.com; Fri, 2 May 2008 14:51:47 +0200
Message-ID: <481B0E57.5030100@stesmi.com>
Date: Fri, 02 May 2008 14:51:35 +0200
From: Stefan Smietanowski <stesmi@stesmi.com>
MIME-Version: 1.0
Subject: Re: query
References: <87604E51C77C4F4988CF1C7F088D562D9BE618@in02ex01.int.cgg.com>
In-Reply-To: <87604E51C77C4F4988CF1C7F088D562D9BE618@in02ex01.int.cgg.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Nandedkar, Rishiraj" <Rishiraj.Nandedkar@cggveritas.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, xfs@oss.sgi.com

Nandedkar, Rishiraj wrote:
> Thank you very much
> 
> 
> 
> -----Original Message-----
> From: Emmanuel Florac [mailto:eflorac@intellique.com] 
> Sent: Friday, May 02, 2008 5:35 PM
> To: Nandedkar, Rishiraj
> Cc: xfs@oss.sgi.com
> Subject: Re: query
> 
> Le Fri, 2 May 2008 16:12:58 +0530
> "Nandedkar, Rishiraj" <Rishiraj.Nandedkar@cggveritas.com> écrivait:
> 
>> Thank you for update but Linux 7.3 means red hat 7 update 3 red hat 3
>> update 5.In our system we are unable to detect disk which is having
>> file system in XFS format. Our system is not able to support it.
>> 2.4.21-32.EL is kenal version on our systems. Please let me know
>> which version should I use in redhat.I am trying this with fedora
>> core 3
> 
> RedHat 7.3 ( or even 8.0 and 9.0 for that matter) are really very old
> and outdated. You'd be much better for pretty much everything with
> something more up-to-date. Back then RedHat 7.x needed a special
> additional CD provided by SGI for XFS support IIRC.
> I'm pretty surprised that RHEL 3 doesn't support XFS though. Anyway,
> RHEL 4 and 5 do without any doubt (I use XFS on them).
> 

Another point could be that if you're used to and like RedHat Linux 7.3
and/or RedHat Enterprise Linux then I think looking at either the newer
RedHat Enterprise Linue (RHEL) 4 or 5 or Fedora is the way to go.

To use XFS in Fedora (http://www.fedoraproject.org) you need to add the
word "xfs" to the installer commandline and also make sure you use a
seperate, small (100MB is enough) partition that's called /boot that's
using ext3 (others work but I recommend using ext3 simply for that
partition).

// Stefan
