Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 18:57:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m631uvSX022088
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 18:56:58 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F96E12D7D86
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 18:57:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id QVO2rzJUalrtdOFE for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 18:57:59 -0700 (PDT)
Message-ID: <486C322D.7080203@sandeen.net>
Date: Wed, 02 Jul 2008 20:58:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] re-remove xfs custom bitops
References: <480EB397.1040304@sandeen.net> <4829C360.5060500@sandeen.net> <482BF841.8050704@sgi.com> <48669A45.1050104@sandeen.net> <4868A114.9080106@sgi.com>
In-Reply-To: <4868A114.9080106@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Donald Douwsma wrote:

> First time round I hit an Oops on xfstests/177 while running the auto group
> on ppc32. I dont seem to hit it running the single test, its intermittent.

Funky.  Do you ever hit it w/ the patch reverted?


-Eric
