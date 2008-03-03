Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 17:01:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2311QtF001645
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 17:01:28 -0800
Subject: Re: Kernel oops / XFS filesystem corruption
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <47C93C32.40006@mathtm.de> <47C9C44D.8080400@sandeen.net> <47C9F5E9.70703@mathtm.de> <47CA043F.5070202@sandeen.net> <47CAF9C4.6090000@mathtm.de>
Content-Transfer-Encoding: 8bit
Date: Mon, 03 Mar 2008 12:02:43 +1100
Message-ID: <op.t7e06t193jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47CAF9C4.6090000@mathtm.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?utf-8?Q?Thomas_M=C3=BCller?= <thomas@mathtm.de>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 06:02:28 +1100, Thomas Müller <thomas@mathtm.de> wrote:

> Eric Sandeen wrote:
>> oh, like a dd image?  great.
> Yup :)
>
>  > You can use xfs_metadump to make a more transportable image...
> I will, if someone needs it.
>
> As said, I have a complete file system image, so if anyone needs
> more information/data, just tell me.

I could use the metadump image for the badness in key lookups that
xfs_repair was reporting.

Thanks,
Barry.
