Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Dec 2007 21:43:45 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBE5hcOe001237
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 21:43:43 -0800
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8529A11422CF
	for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 21:43:49 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183]) by cuda.sgi.com with ESMTP id Xc9uu0DJANtjG1B7 for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 21:43:49 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id k22so1654630waf.18
        for <xfs@oss.sgi.com>; Thu, 13 Dec 2007 21:43:48 -0800 (PST)
Message-ID: <f0e429340712132137j27b92e3ew8cadffef0208edd5@mail.gmail.com>
Date: Fri, 14 Dec 2007 06:37:23 +0100
From: "KE Liew" <ke.liew@gmail.com>
Subject: Re: mount: Function not implemented
In-Reply-To: <20071214052833.GM4396912@sgi.com>
MIME-Version: 1.0
References: <f0e429340712130746i9b24c15j8dd8f53a9da2c4c4@mail.gmail.com>
	 <20071213224749.GJ4396912@sgi.com> <47620148.2060401@sandeen.net>
	 <20071214052833.GM4396912@sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Dec 14, 2007 6:28 AM, David Chinner <dgc@sgi.com> wrote:

> So, key questions:
>
>        1. What platform is this?


Debian Etch.


>
>        2. What page size is being used?


Pardon my lack of knowledge, but what do you mean by page size?


>
>        3. what kernel is being run?


Stock kernel 2.6.18-5-686


>
>        4. What was the mkfs command used to make the filesystem?


from .bash_history - mkfs.xfs -f /dev/hdb1


>
>        5. how did you mount this filesystem in the first place?


As mentioned, the usual mount -t xfs /dev/hdb1 /path/to Tried both /dev/hdb
and /dev/hdb1, where hdb1 was the first I tried.


KwangErn


[[HTML alternate version deleted]]
