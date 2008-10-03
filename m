Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Oct 2008 13:38:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m93Kc8Bl027612
	for <xfs@oss.sgi.com>; Fri, 3 Oct 2008 13:38:08 -0700
Received: from smtp1-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 265DB9D53F2
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2008 13:39:44 -0700 (PDT)
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27]) by cuda.sgi.com with ESMTP id LRFM200PGLPoHOCj for <xfs@oss.sgi.com>; Fri, 03 Oct 2008 13:39:44 -0700 (PDT)
Date: Fri, 3 Oct 2008 22:39:20 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: what is the FS size limit for xfs_repair ?
Message-ID: <20081003223920.107aeb43@galadriel.home>
In-Reply-To: <25446eb90810030823g70506145o9aef9ed3832abfe@mail.gmail.com>
References: <20081003170452.50a7ec78@harpe.intellique.com>
	<25446eb90810030823g70506145o9aef9ed3832abfe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: James Braid <jamesb@loreland.org>
Cc: xfs@oss.sgi.com

Le Fri, 3 Oct 2008 16:23:41 +0100 vous écriviez:

> The limit is how much memory a 32-bit process can allocate - it's not
> a limit of xfs_repair itself.

OK, that makes sense. I'll keep my 64 bits xfs_repair at hand :)

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
