Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 23:28:48 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q6SiUQ019930
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 23:28:45 -0700
Received: from zimbra.vpac.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3E30182A439
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 23:29:44 -0700 (PDT)
Received: from zimbra.vpac.org (zimbra.vpac.org [202.158.218.6]) by cuda.sgi.com with ESMTP id pyoiocyE7QrlNXE8 for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 23:29:44 -0700 (PDT)
Message-ID: <48633754.6070709@vpac.org>
Date: Thu, 26 Jun 2008 16:29:40 +1000
From: Brian May <brian@vpac.org>
MIME-Version: 1.0
Subject: Re: open sleeps
References: <4859EE54.6050801@vpac.org> <20080619062118.GY3700@disturbed> <4859FF40.8010206@vpac.org> <20080619084311.GA16736@infradead.org> <485B0C47.5060001@vpac.org> <485B2DE4.2080907@vpac.org>
In-Reply-To: <485B2DE4.2080907@vpac.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brian May <brian@vpac.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hello,

Thanks for your help.

Just a followup: Every indication seems to be that it is the firewall in 
the virus scanner we use, F-Secure, that prevents Windows from releasing 
oplocks properly. After turning off the firewall, the oplocks get 
released and there is no problem. Possibly related to the timing of wpkg 
being invoked before system logons too.

Might be time to consider another virus scanner/firewall solution.

Brian May
