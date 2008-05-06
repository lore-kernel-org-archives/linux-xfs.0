Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 09:23:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m46GMjK0031461
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 09:22:50 -0700
Received: from relay-dm.club-internet.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4972132D7B
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 09:23:30 -0700 (PDT)
Received: from relay-dm.club-internet.fr (relay-dm.club-internet.fr [194.158.104.222]) by cuda.sgi.com with ESMTP id Clye0ICvNM2duYOD for <xfs@oss.sgi.com>; Tue, 06 May 2008 09:23:30 -0700 (PDT)
Received: from petole.dyndns.org (i05m-87-90-240-206.d4.club-internet.fr [87.90.240.206])
	by relay-dm.club-internet.fr (Postfix) with ESMTP id 5FE7825619
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 18:23:28 +0200 (CEST)
Received: from petole.dyndns.org (petole.dyndns.org [192.168.2.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by petole.dyndns.org (Postfix) with ESMTP id 452C9BF02
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 18:23:28 +0200 (CEST)
Date: Tue, 6 May 2008 18:23:28 +0200
From: Nicolas KOWALSKI <niko@petole.dyndns.org>
Subject: Re: XFS for lots of small files
In-Reply-To: <4820832B.3070903@dubielvitrum.pl>
Message-ID: <alpine.DEB.1.10.0805061817410.17107@petole.dyndns.org>
References: <4820832B.3070903@dubielvitrum.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Tue, 6 May 2008, Leszek Dubiel wrote:

> Hello!

Hello,

> Is that normal? What I am doing wrong?

For metadata intensive work, you should consider a little bit of tuning. 

See this usefull advice:
http://thread.gmane.org/gmane.comp.file-systems.xfs.general/21239/focus=21240

-- 
Nicolas
