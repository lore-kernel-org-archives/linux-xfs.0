Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Oct 2006 09:45:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9RGjXaG017683
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 09:45:34 -0700
Received: from emailer.gwdg.de (emailer.gwdg.de [134.76.10.24])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6E324DC114
	for <xfs@oss.sgi.com>; Fri, 27 Oct 2006 09:44:47 -0700 (PDT)
Date: Fri, 27 Oct 2006 18:41:56 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [opensuse] xfs file system
In-Reply-To: <20061027145304.GA8247@arcor.de>
Message-ID: <Pine.LNX.4.61.0610271834480.13894@yvahk01.tjqt.qr>
References: <8a24510d0610191243t164993ecj7fa04d1110ffa0bc@mail.gmail.com>
 <200610210440.22170.gholmer@ameritech.net> <45421504.6040501@grafikern.no>
 <20061027145304.GA8247@arcor.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Matthias G. Eckermann" <mge@arcor.de>
Cc: "Kenneth Aar, Grafikern.no" <kenneth@grafikern.no>, opensuse@opensuse.org, xfs@oss.sgi.com


>> | > my question is, are there people here who have some 
>> | > experience with XFS?
>> |
>> | I've been using it for several years, both at home and on the
>> | servers at| work.  Never had a problem.
>>
>> I have heard that it is more prone to fault/corruption if you
>> yank the powercord or experience any form of unexpected
>> poweroutage...
>
>* "heard" from whom?
>* "more"  than what?
>
>Well, every filesystem will have to recover after "yank the
>powercord or experience any form of unexpected poweroutage".
>
>But compared to other FSs "xfs" is like heaven, xfs_repair
>works pretty reliable, especially after "forced crashes".


Added xfs list for great justice:

Yeah but I would be more happy if it did not zero out files (perhaps 
adding a new mount option?) but leave them as-is. I am more concerned 
about text files keeping their shape as far as possible rather than 
running into a corrupt binary configuration file.


	-`J'
-- 
