Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 19:07:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3927mxM022390
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 19:07:51 -0700
Date: Wed, 09 Apr 2008 12:12:29 +1000
Subject: Re: Lost+found
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <1207632033.11530.10.camel@localhost.localdomain>
Content-Transfer-Encoding: 7bit
Message-ID: <op.t9bm23aa3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <1207632033.11530.10.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeffrey Sandel <webmaster@javainbaja.com>, xfs@oss.sgi.com

On Tue, 08 Apr 2008 15:20:33 +1000, Jeffrey Sandel  
<webmaster@javainbaja.com> wrote:

> Recently I ran xfs_repair due to a firmware upgrade on an unmounted
> disk. The repair recovered the data but moved it to the lost+found
> directory.
>
> How do I recover file names and ownership?

The only real options you have AFAIK is the file command to try and  
identify
what type of file it is and just manually inspecting the files.

Then, you might be able to derive its filename and where it came from.

Regards,
Barry.
