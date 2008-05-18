Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 05:44:55 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4ICiqTO028188
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 05:44:53 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BB8A16E9E0F
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 05:45:39 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id R4865lasW7HGbQu6 for <xfs@oss.sgi.com>; Sun, 18 May 2008 05:45:39 -0700 (PDT)
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 883D83227F3
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 14:45:38 +0200 (CEST)
Received: from galadriel.home (pla78-1-82-235-234-79.fbx.proxad.net [82.235.234.79])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 47F28322821
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 14:45:38 +0200 (CEST)
Date: Sun, 18 May 2008 14:45:30 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080518144530.78989768@galadriel.home>
In-Reply-To: <20080516222755.3e557c00@galadriel.home>
References: <20080516222755.3e557c00@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com

Le Fri, 16 May 2008 22:27:55 +0200 vous écriviez:

> History : this filesystem was extended (xfs_growfs) from 16TB to 24.
> 

One important thing I forgot to mention : some time before I
have extended the FS from 16 to 24 TB, the FS got filled up commpletely
(186MB free!!!). I've asked the user to make some room to avoid
problems, so they freed 1.6 TB in a couple of days before growing up
the FS. Is it possible that something got wrong with the filesystem
being too filled?

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
