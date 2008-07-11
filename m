Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:26:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B4Prqu015501
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:25:53 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BADD1BB47A7
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:26:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id a6AHhclhksbFK2Mh for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:26:59 -0700 (PDT)
Message-ID: <4876E112.4010607@sandeen.net>
Date: Thu, 10 Jul 2008 23:26:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <4876D1C3.4000006@sgi.com> <20080711040447.GC11558@disturbed> <4876DD2D.2010903@sandeen.net> <4876DDE3.7020801@sgi.com> <4876DF17.9090904@sandeen.net>
In-Reply-To: <4876DF17.9090904@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: markgw@sgi.com, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:

> But, w/ the patch it actually deadlocked really quickly (< 2000 inodes
> written)

ok testing a fixed up version ...

will let you know in my AM if it survived.

-Eric
