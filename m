Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 03:28:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39ASZlX016559
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 03:28:36 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CB21107B126
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 03:29:11 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id kNUgH1Cancpb2D1Y for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 03:29:11 -0700 (PDT)
Date: Wed, 9 Apr 2008 06:28:39 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Lost+found
In-Reply-To: <op.t9bm23aa3jf8g2@pc-bnaujok.melbourne.sgi.com>
Message-ID: <alpine.DEB.1.10.0804090628080.322@p34.internal.lan>
References: <1207632033.11530.10.camel@localhost.localdomain> <op.t9bm23aa3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Jeffrey Sandel <webmaster@javainbaja.com>, xfs@oss.sgi.com



On Wed, 9 Apr 2008, Barry Naujok wrote:

> On Tue, 08 Apr 2008 15:20:33 +1000, Jeffrey Sandel <webmaster@javainbaja.com> 
> wrote:
>
>> Recently I ran xfs_repair due to a firmware upgrade on an unmounted
>> disk. The repair recovered the data but moved it to the lost+found
>> directory.
>> 
>> How do I recover file names and ownership?
>
> The only real options you have AFAIK is the file command to try and identify
> what type of file it is and just manually inspecting the files.
>
> Then, you might be able to derive its filename and where it came from.
>
> Regards,
> Barry.
>

Is there any chance this process could ever be improved so that the files 
are restored back to their original locations or there is something that 
keeps track of where they were located?

Justin.
