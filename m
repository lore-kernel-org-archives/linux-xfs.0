Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Dec 2007 15:44:19 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBUNi5RP016359
	for <xfs@oss.sgi.com>; Sun, 30 Dec 2007 15:44:14 -0800
Received: from mail-out.m-online.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF9F34CDC83
	for <xfs@oss.sgi.com>; Sun, 30 Dec 2007 15:44:17 -0800 (PST)
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9]) by cuda.sgi.com with ESMTP id Yn82c8cO85EUxWtU for <xfs@oss.sgi.com>; Sun, 30 Dec 2007 15:44:17 -0800 (PST)
From: Wolfgang Denk <wd@denx.de>
Subject: Re: New XFS benchmarks using David Chinner's recommendations for XFS-based optimizations.
Mime-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8bit
In-reply-to: Your message of "Mon, 31 Dec 2007 01:33:14 +0200."
             <5d96567b0712301533v3a7fcfd1pfce02563526a39bf@mail.gmail.com>
Date: Mon, 31 Dec 2007 00:44:15 +0100
Message-Id: <20071230234415.1E11B24755@gemini.denx.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Raz <raziebe@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, linux-raid@vger.kernel.org

In message <5d96567b0712301533v3a7fcfd1pfce02563526a39bf@mail.gmail.com> you wrote:
> what is nobarrier ?
...
> > > # mount -o logbsize=256k,nobarrier <dev> <mtpt>

See http://oss.sgi.com/projects/xfs/faq.html

Q: How can I address the problem with the write cache?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
One of the advantages of being a captain is being able to ask for ad-
vice without necessarily having to take it.
	-- Kirk, "Dagger of the Mind", stardate 2715.2
