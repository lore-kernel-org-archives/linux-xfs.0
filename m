Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Feb 2008 01:59:42 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m169xbG2010081
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2008 01:59:39 -0800
Received: from magneto.unbit.it (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31351DA0DAA
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2008 01:59:59 -0800 (PST)
Received: from magneto.unbit.it (80.68.207.61 [80.68.207.61]) by cuda.sgi.com with ESMTP id eFMu77ziXc0ExEm6 for <xfs@oss.sgi.com>; Wed, 06 Feb 2008 01:59:59 -0800 (PST)
Message-ID: <39714.212.48.3.175.1202291997.squirrel@manage.unbit.it>
In-Reply-To: <20080205052418.GU155259@sgi.com>
References: <20080205052418.GU155259@sgi.com>
Date: Wed, 6 Feb 2008 10:59:57 +0100 (CET)
Subject: Re: [PATCH] Possible fix for 2.6.24 xfs_file_readdir crash
From: ".:deadhead:." <deadhead@goodfellow.it>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Sven Geggus <lists@fuchsschwanzdomain.de>, xfs@oss.sgi.com, Tobias Ulmer <tu@emlix.com>, Andrea Perotti <andreamtp@goodfellow.it>

> Sven, Tomas, Andrea:
>
> Can you try the patch attached below to see if it fixes the
> xfs_file_readdir() oops you are seeing and let me know if it fixes
> the problem?

Works like a charm here :D

Thank you for your fast fix !


cheers

Andrea
