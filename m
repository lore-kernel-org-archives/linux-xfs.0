Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 09:26:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5FGQfxf014041
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:26:41 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69C98233D4A
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:27:38 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153]) by cuda.sgi.com with ESMTP id M4tk6hjm9Y5BJp0D for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:27:38 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so3257200fgb.8
        for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 09:27:37 -0700 (PDT)
Message-ID: <6101e8c40806150927g7ec36ad7w92ad0c2eebd85437@mail.gmail.com>
Date: Sun, 15 Jun 2008 18:27:36 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older 2.6.25.y)
In-Reply-To: <6101e8c40806150917w5d17e31wd8b55e1d38da2411@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>
	 <48547604.9060700@sandeen.net>
	 <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com>
	 <48553C11.2060606@sandeen.net>
	 <6101e8c40806150909s4f9b95d2u685c09a0ba3767e3@mail.gmail.com>
	 <48553F53.7000208@sandeen.net>
	 <6101e8c40806150914k1226611ej52b20b7bb9ffa9d5@mail.gmail.com>
	 <6101e8c40806150917w5d17e31wd8b55e1d38da2411@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

but now it was him that you say the antecedents apt-get update &
upgrade and git-update-tree (is is a script, that updated 3 git tree
(linux-2.6, linux-2.6.25.y and stable-queue)) , that is heavy disc i/o
with much small files

On 6/15/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> hmm, the system have two XFS partition the / (sda4) and /home (sda3)
>
> /dev/sda3 on /home type xfs (rw,noexec,nosuid,nodev)
> /dev/sda4 on / type xfs (rw)
>
> On 6/15/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
>> sorry, but I did not learn English, is going a little bit slowly in this
>> manner.
>>
>> yeah, under poweroff (init 0) panics the system
>>
>> On 6/15/08, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> Oliver Pinter wrote:
>>>> this is the debian way of the unmounting the root fs:
>>>
>>> Ok we're slowly getting to useful information.
>>>
>>> So you were shutting down the system when the panic happened, correct?
>>>
>>> -Eric
>>>
>>>
>>
>>
>> --
>> Thanks,
>> Oliver
>>
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
