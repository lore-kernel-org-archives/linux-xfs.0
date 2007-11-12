Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 06:19:26 -0800 (PST)
Received: from r2d2.neofacto.lu (mail.neofacto.lu [158.64.60.195])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lACEICKR008576
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 06:18:16 -0800
Received: from localhost (localhost [127.0.0.1])
	by r2d2.neofacto.lu (Postfix) with ESMTP id E39C6C3045
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 13:20:24 +0100 (CET)
Received: from r2d2.neofacto.lu ([127.0.0.1])
	by localhost (r2d2.neofacto.lu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ec4w8O+pedUu for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2007 13:20:11 +0100 (CET)
Received: from [192.168.1.166] (SU105.tudor.lu [158.64.4.205])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by r2d2.neofacto.lu (Postfix) with ESMTP id 84217C3045
	for <xfs@oss.sgi.com>; Mon, 12 Nov 2007 13:20:02 +0100 (CET)
Message-ID: <473844ED.7080605@jamendo.com>
Date: Mon, 12 Nov 2007 13:19:57 +0100
From: Amandine AUPETIT <amandine@jamendo.com>
MIME-Version: 1.0
Subject: xfs options
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi :)

I have a 7tb XFS filesystem. The partition is supposed to stock big 
files between 2mo and 50mo. Quite no small files.

So i'm trying to adapt the mount option to what I need, and what I need 
is security. I want to be sure that NONE of the files will be lost, even 
if there's a power failure.
For now, I just tried the noatime mount option, I know there is a lot of 
options, but I don't really understand what they stand for.

Do you have any suggestion to make my filesystem safer ?

Thanks

Amandine
