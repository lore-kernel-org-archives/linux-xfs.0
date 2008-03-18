Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Mar 2008 05:36:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ICaCdO012501
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 05:36:13 -0700
Received: from smtp01av.ntr.oleane.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E824FC23CD
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 05:36:44 -0700 (PDT)
Received: from smtp01av.ntr.oleane.net (smtp-out2.net.av.oleane.com [195.25.12.12]) by cuda.sgi.com with ESMTP id W1b3UK6mLSKeRo2W for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 05:36:44 -0700 (PDT)
Received: from Antivirus (localhost [127.0.0.1]) by smtp01av.ntr.oleane.net with ESMTP id m2ICBgxS011497
	for <xfs@oss.sgi.com>;
	Tue, 18 Mar 2008 13:11:42 +0100
Received: from [172.16.0.11] (151-15.252-81.static-ip.oleane.fr [81.252.15.151])
	by smtp01av.ntr.oleane.net (8.12.11.20060308/8.12.11/8.12-FT) with ESMTP id m2ICBfmM011457
	for <xfs@oss.sgi.com>; Tue, 18 Mar 2008 13:11:41 +0100
Subject: Update of XFSPROG XFSDUMP on linux kernel 2.4.22
Message-ID: <1205842046.47dfb07ede86d@hermesadm.chb.fr>
Date: Tue, 18 Mar 2008 13:07:26 +0100 (CET)
From: Xavier Poirier <xpoirier@ch-bourg01.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all XFS ML Users !

I'm Xavier from France.

I had installed two years ago a linux server with 2 XFS Partitions.

All is working like a charm !

* Except, 

xfsrestore command, that is often crashing (one time on two) with a dump file of 35Go


Here is my versions descriptions:

- Linux Mandrake 9.2 kernel 2.4.22
- XFSDUMP 2.2.13
- XFSDUMP 2.5.4  (installed by RPM) 


My question is :

Is it better to update the XFS programs to newer versions, or update my linux kernel, to avoid
problems ?

I've tryed to find some older distribs of xfsdump, but without succes (like 2.2.33)
the most recent distribs fails with the configure at manual install ...

What is the best for you ?
I really need your help before take a decision!


Thanks



Xavier
