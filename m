Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9ECC77CBF
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 20:12:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66E138F8033
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 18:12:32 -0700 (PDT)
Received: from mail-pd0-f174.google.com (mail-pd0-f174.google.com
	[209.85.192.174]) by cuda.sgi.com with ESMTP id
	jSMMRGfIRBTXzi9K (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 18:12:31 -0700 (PDT)
Received: by mail-pd0-f174.google.com with SMTP id y13so14845pdi.5
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 18:12:30 -0700 (PDT)
Message-ID: <5216B6FC.5050908@amacapital.net>
Date: Thu, 22 Aug 2013 18:12:28 -0700
From: Andy Lutomirski <luto@amacapital.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped writes
References: <cover.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andy Lutomirski <luto@amacapital.net>
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>

On 08/22/2013 05:03 PM, Andy Lutomirski wrote:
> Writes via mmap currently update mtime and ctime in ->page_mkwrite.

The subject should be [PATCH v4 0.7]...  Sorry for the cut-and-pasteo.

--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
