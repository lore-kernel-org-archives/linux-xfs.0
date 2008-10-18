Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 16:26:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9INQBqo026682
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 16:26:11 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96831AC4C8A
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 16:27:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id bXYgKhBBkYH0YhuC for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 16:27:55 -0700 (PDT)
Date: Sat, 18 Oct 2008 19:27:53 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: kernel 2.6.27.2 (32bit) filesystem is read-only
Message-ID: <alpine.DEB.1.10.0810181926380.20575@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

all 2.6.26.x kernels work ok,
make oldconfig on 2.6.27.2, filesystem mounted read-only at boot 
booted back to 2.6.26.x, back to normal
barriers are on by default (single disk system)
