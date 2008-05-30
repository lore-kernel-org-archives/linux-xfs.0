Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 17:51:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4U0pVao030901
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 17:51:33 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 829C71CF276
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 17:52:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 6MoOhBNMsenT4lF4 for <xfs@oss.sgi.com>; Thu, 29 May 2008 17:52:24 -0700 (PDT)
Message-ID: <483F4FC7.3060801@sandeen.net>
Date: Thu, 29 May 2008 19:52:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: REVIEW: Enhance xfs_repair -P option to disable libxfs xfs_buf_t
 locking
References: <op.ubxy8gk63jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ubxy8gk63jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Barry Naujok wrote:
> I hope the subject is explanation enough :)

not really ;)

Hum, if I normally lock why do I not want to lock?  Locking good?
Locking bad?  Locking too slow?  locking for what?  Incoherency ok?  Man
page updates? :)

-Eric
